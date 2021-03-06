desc 'This task updates our Analytics Warehouse tables.'
task update_tables: :environment do
  puts 'Updating tables...'
  a = AnalyticsWarehouse.new()

  puts 'Updating user_dimensions...'
  a.reset_table :user_dimensions
  a.update_table :user_dimensions

  puts 'Updating organization_dimensions...'
  a.reset_table :organization_dimensions
  a.update_table :organization_dimensions

  puts 'Updating space_dimensions...'
  a.reset_table :space_dimensions
  a.update_table :space_dimensions

  puts 'Updating edits...'
  pgr = a.connection.exec "SELECT MAX(UPPER(duration)) AS ts FROM guesstimate_#{Rails.env}.edits"
  min_updated_at = DateTime.parse pgr[0]['ts']
  puts "Adding edits since #{min_updated_at.to_s}"
  a.update_table :edits, min_updated_at

  puts 'Done'
end

desc 'This task updates the space view counts.'
task update_view_counts: :environment do
  puts 'Updating view counts...'
  AnalyticsWarehouse::update_view_counts!
  puts 'Done'
end

desc 'This task takes screenshots of any spaces that need them.'
task take_snapshots: :environment do
  spaces = Space.is_public.where('updated_at > snapshot_timestamp OR snapshot_timestamp IS NULL')
  puts "Taking snapshots of #{spaces.count} #{'space'.pluralize spaces.count}"
  spaces.find_each do |space|
    space.take_snapshot
    while (Thread.list.count > 10)
      sleep 0.01
    end
  end
end
