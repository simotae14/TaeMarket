class Sale < ActiveRecord::Base
  before_create :generate_guid
  belongs_to :content
  include AASM

  # definisco gli STATE MACHINE
  aasm column: 'state' do
    state :sleeping, :initial => true
    state :running
    state :completed
    state :errored
  
    # quindi la transizione a running si attiva dopo l'azione di charge_card
    # passando quindi da sleeping a running
    event :running, after: :charge_card do
      transitions from: :sleeping, to: :running
    end
    
    # l'evento complete si attiva quando la transizione va da :running a :completed
    event :complete do
      transitions from: :running, to: :completed
    end
    
    # l'evento fail si attiva quando la transizione va da :running a :errored
    event :fail do
      transitions from: :running, to: :errored
    end
  end
  
  def charge_card
    begin
      save!
      charge = Stripe::Charge.create(
        amount: self.amount,
        currency: 'eur',
        card: self.stripe_token,
        description: "vendita di un contenuto"
      )
      
      self.update(stripe_id: charge.id)
      self.complete!
    
    rescue Stripe::StripeError  => e
      self.update_attributes(error: e.message)
      self.fail!
    end 
  end
  
  private
    def generate_guid
      self.guid = SecureRandom.uuid()
    end

end
