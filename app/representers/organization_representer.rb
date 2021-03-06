require 'roar/decorator'

class OrganizationRepresenter < Roar::Decorator
  include Roar::JSON
  include Roar::JSON::HAL

  property :id
  property :name
  property :picture
  property :admin_id
  property :api_enabled, if: ->(user_options:, **) { user_options[:current_user_is_admin] }
  property :api_token, if: ->(user_options:, **) { user_options[:current_user_is_admin] }

  property :admin, class: User, embedded: true  do
    property :id
    property :username, as: "name"
    property :picture
  end

  collection :invitations,
    class: UserOrganizationInvitation,
    decorator: OrganizationInvitationRepresenter,
    if: ->(user_options:, **) { user_options[:current_user_is_admin] }

  collection :memberships,
    class: UserOrganizationMembership,
    decorator: OrganizationMembershipRepresenter,
    if: ->(user_options:, **) { user_options[:current_user_is_member] }

  collection :facts,
    class: Fact,
    decorator: FactRepresenter,
    if: ->(user_options:, **) { user_options[:current_user_is_member] }

  collection :fact_categories,
    class: FactCategory,
    decorator: FactCategoryRepresenter,
    if: ->(user_options:, **) { user_options[:current_user_is_member] }

  collection :intermediate_spaces,
    class: Space,
    decorator: SpaceWithoutOrganizationRepresenter,
    if: ->(user_options:, **) { user_options[:current_user_is_member] }

  property :plan_details,
    decorator: PlanRepresenter,
    class: Plan,
    as: 'plan',
    if: ->(user_options:, **) { user_options[:current_user_is_member] }

  property :account,
    decorator: AccountRepresenter,
    class: OrganizationAccount,
    if: ->(user_options:, **) { user_options[:current_user_is_admin] }
end
