module UberModel
  module Persistence
    def save(*)
      run_callbacks :save do
        result = new_record? ? create : update
        changed_attributes.clear if result
        result
      end
    end

    def create
      run_callbacks :create do
        true
      end
    end

    def update
      run_callbacks :update do
        true
      end
    end

    def destroy
      run_callbacks :destroy do
      end
    end

    def reload
    end

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
