# frozen_string_literal: true

# This migration comes from decidim_budgets (originally 20170410074214)
# This file has been modified by `decidim upgrade:migrations` task on 2025-11-25 09:35:06 UTC
class RemoveNotNullReferenceBudgets < ActiveRecord::Migration[5.0]
  def change
    change_column_null :decidim_budgets_projects, :reference, true
  end
end
