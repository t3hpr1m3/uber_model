module UberModel

  # Methods used to perform the CRUD operations on a model.  Also includes
  # getters to determine the persisted state of a model.
  module Persistence

    # Main persistence method.  Will call {#create create} or 
    # {#update update} depending on the model's current persisted state.
    def save(*)
      run_callbacks :save do
        result = new_record? ? create : update
        changed_attributes.clear if result
        result
      end
    end

    # Persistence method for new models.
    def create
      run_callbacks :create do
        true
      end
    end

    # Persistence method for existing models.
    def update
      run_callbacks :update do
        true
      end
    end

    # Destruction method (deletion)
    def destroy
      run_callbacks :destroy do
      end
    end

    # Attempts to read a model's attributes again from the data source.
    def reload
    end

    # Mass attribute update (will perform a {#save save} automatically).
    def update_attributes(attributes)
    end

    def new_record?
      !@persisted
    end

    def destroyed?
      @destroyed
    end

    def persisted?
      @persisted && !destroyed?
    end
  end
end
