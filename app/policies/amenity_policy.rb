class AmenityPolicy < BasePolicy
  def index?
    true
  end

  def show?
    true
  end

  def create?
    user&.moderator? || false
  end

  def new?
    create?
  end

  def update?
    create?
  end

  def edit?
    update?
  end

  def destroy?
    create?
  end

  class Scope < BasePolicy::Scope
    def resolve
      scope.all
    end
  end
end
