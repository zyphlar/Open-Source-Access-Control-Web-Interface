class Ability
  include CanCan::Ability

  def initialize(user)
    can :read, Mac # Anonymous can read mac
    can :scan, Mac # Need anonymous so CRON can scan

    if !user.nil?

      # By default, users can only see their own stuff
      can :read, Card, :user_id => user.id
      can :read, Certification
      can :read_details, Mac
      can [:update], Mac, :user_id => nil
      can [:create,:update], Mac, :user_id => user.id
      can :read, Payment, :user_id => user.id
      can :read, UserCertification, :user_id => user.id
      can :read, User, :id => user.id #TODO: why can users update themselves? Maybe because Devise doesn't check users/edit?
      can :compose_email, User
      can :send_email, User

      if user.card_access_enabled
        can :access_doors_remotely, :door_access
      end

      # Instructors can manage certs and see users
      if user.instructor? 
        can :manage, Certification
        can [:create,:read], User, :hidden => [nil,false]
        can [:create,:read], UserCertification
        can [:update,:destroy], UserCertification, :created_by => user.id
      end
      # Users can see others' stuff if they've been oriented
      unless user.orientation.blank?
        can [:read,:new_member_report,:activity], User, :hidden => [nil,false]
        can :read, UserCertification
      end 

      # Accountants can manage payments
      if user.accountant?
        can :manage, Payment
        can :manage, Ipn
        can :manage, PaypalCsv
      end

      # Admins can manage all
      if user.admin?
        can :manage, :all
      end

      # Prevent all destruction for now
      #cannot :destroy, User
      #cannot :destroy, Card
      cannot :destroy, Certification
      cannot :destroy, Mac
      cannot :destroy, MacLog
      #cannot :destroy, UserCertification
      cannot :destroy, DoorLog
      # no exception for destroying payments
    end 
    # Define abilities for the passed in user here. For example:
    #
    #   user ||= User.new # guest user (not logged in)
    #   if user.admin?
    #     can :manage, :all
    #   else
    #     can :read, :all
    #   end
    #
    # The first argument to `can` is the action you are giving the user permission to do.
    # If you pass :manage it will apply to every action. Other common actions here are
    # :read, :create, :update and :destroy.
    #
    # The second argument is the resource the user can perform the action on. If you pass
    # :all it will apply to every resource. Otherwise pass a Ruby class of the resource.
    #
    # The third argument is an optional hash of conditions to further filter the objects.
    # For example, here the user can only update published articles.
    #
    #   can :update, Article, :published => true
    #
    # See the wiki for details: https://github.com/ryanb/cancan/wiki/Defining-Abilities
  end
end
