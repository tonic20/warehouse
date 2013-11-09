module ReportsHelper
  def pretty_quantity(equipment, quantity)
    case Equipment::UNITS.index(equipment.units)
    when :pieces
      "#{quantity.to_i} #{I18n.t("units.#{Equipment::UNITS.index(equipment.units)}")}"
    else
      "#{quantity} #{I18n.t("units.#{Equipment::UNITS.index(equipment.units)}")}"
    end
  end
end

