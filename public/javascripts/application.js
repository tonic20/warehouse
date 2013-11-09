$(document).ready(function() {
  $(".datepicker").datepicker({dateFormat:'dd.mm.yy'});

  $("a.show_details").live("click", function(e) {
    var $this = $(this),
      $td = $this.parent(),
      $tr = $this.parents("tr"),
      $form = $("form.search"),
      $id = $tr.attr("data-id");

    if ($this.hasClass("expanded")) {
      $td.append("<img src=\"/images/loader.gif\" />");

      stock_id = $form.find("#stock_id option:selected").val();
      date_from = $form.find("#date_from").val();
      date_to = $form.find("#date_to").val();

      $.ajax({
        url: "/reports/equipment_history/" + $id,
        data: {
          "stock_id": stock_id,
          "date_from": date_from,
          "date_to": date_to
        },
        success: function(response) {
          $td.find("img").remove();
          $tr.after(response);
        }
      });

    } else {
      $td.find("img").remove();
      $this.parents("table").find("tr.equipment" + $id).remove();
    };
    $this.toggleClass("expanded");

    e.preventDefault();
  });
});

