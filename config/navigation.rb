SimpleNavigation::Configuration.run do |navigation|
  navigation.items do |primary|
    primary.item :stock_items, 'Склад', stock_items_path do |stock_items|
      stock_items.item :stock_items_index, 'Просмотр', stock_items_path
      stock_items.item :stock_items_new, 'Создать документ', new_stock_item_path
    end
    primary.item :reports, 'Отчёты', reports_equipment_path do |reports|
      reports.item :reports_equipment, 'Количество по складу', reports_equipment_path
      reports.item :reports_equipment_summary, 'Cуммарное количество', reports_equipment_summary_path if current_user.admin?
    end
    primary.item :admin, 'Справочники', equipments_path do |admin|
      admin.item :equipments, 'Оборудование', equipments_path
      admin.item :categories, 'Категории', categories_path
      admin.item :stocks, 'Склады', stocks_path if current_user.admin?
      admin.item :users, 'Пользователи', users_path if current_user.admin?
    end
    primary.item :help, 'Помощь', help_path
  end
end

