view: order_items {
  sql_table_name: public.order_items ;;

  parameter: metric_selector {
    type: string
    allowed_value: {
      label: "Total Cost"
      value: "tc"
    }
    allowed_value: {
      label: "Total Sales Price"
      value: "tsp"
    }
    allowed_value: {
      label: "Total Retail Price"
      value: "trp"
    }
  }

  measure: metric {
    label_from_parameter: metric_selector
    type: number
    value_format: "$0.0,\"K\""
    sql:
      CASE
        WHEN {% parameter metric_selector %} = 'tc' THEN
          ${inventory_items.total_cost}
        WHEN {% parameter metric_selector %} = 'tsp' THEN
          ${total_sale_price}
        WHEN {% parameter metric_selector %} = 'trp' THEN
          ${products.total_retail_price}
        ELSE
          NULL
      END ;;
  }

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
}
