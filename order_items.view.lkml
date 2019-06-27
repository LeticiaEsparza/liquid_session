view: order_items {
  sql_table_name: public.order_items ;;

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension: inventory_item_id {
    type: number
    # hidden: yes
    sql: ${TABLE}.inventory_item_id ;;
  }

  dimension: order_id {
    type: number
    # hidden: yes
    sql: ${TABLE}.order_id ;;
  }

  dimension_group: returned {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.returned_at ;;
  }

  dimension: sale_price {
    type: number
    sql: ${TABLE}.sale_price ;;
  }

  measure: count {
    type: count
    drill_fields: [id, orders.id, inventory_items.id]
  }

  measure: total_sale_price {
    type: sum
    sql: ${TABLE}.sale_price ;;
    value_format_name: usd
  }

  parameter: metric_selector {
    type: string
    allowed_value: {
      label: "Total Sale Price"
      value: "total_sale_price"
    }
    allowed_value: {
      label: "Total Retail Price"
      value: "total_retail_price"
    }
    allowed_value: {
      label: "Total Cost"
      value: "total_cost"
    }
  }

  measure: metric {
    label_from_parameter: metric_selector
    #label changes in a visualization (table example)
    type: number
    value_format_name: usd
    sql:
      CASE
        WHEN {% parameter metric_selector %} = 'total_sale_price' THEN
          ${order_items.total_sale_price}
        WHEN {% parameter metric_selector %} = 'total_retail_price' THEN
          ${products.total_retail_price}
        WHEN {% parameter metric_selector %} = 'total_cost' THEN
          ${inventory_items.total_cost}
        ELSE
          NULL
      END ;;
  }

}
