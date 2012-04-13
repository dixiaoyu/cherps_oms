pdf.text "Redemption Reservation Receipt 00000{@reservation.id}", :size => 30, :style => :bold

pdf.move_down(30)

items = @reservation.cart.line_items.map do |item|
  [
    item.item_desc,
    item.eff_from.to_date,
    item.eff_to.to_date,
  ]
end

pdf.table items, :border_style => :grid,
  :row_colors => ["FFFFFF","DDDDDD"],
  :headers => ["Product", "Qty", "Unit Price"],
  :align => { 0 => :left, 1 => :right, 2 => :right, 3 => :right }

pdf.move_down(10)

pdf.text "Total Price: #{number_to_currency(@order.cart.total_price)}", :size => 16, :style => :bold