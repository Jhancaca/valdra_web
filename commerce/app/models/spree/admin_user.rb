module Spree
  # Administrative identity only. It deliberately uses a separate table from
  # customers so staff authorization never depends on customer account state.
  class AdminUser < Spree.base_class
    self.table_name = "spree_admin_users"

    devise :database_authenticatable, :recoverable, :validatable, :lockable, :timeoutable

    include Spree::AdminUserMethods
  end
end
