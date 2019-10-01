view: orders {
  sql_table_name: public.orders ;;

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension_group: created {
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
    sql: ${TABLE}.created_at ;;
  }

  dimension: status {
    type: string
    sql: ${TABLE}.status ;;
  }

  dimension: traffic_source {
    type: string
    sql: ${TABLE}.traffic_source ;;
  }

  filter: traffic_source_filter {
    type: string
    suggest_dimension: traffic_source
  }

  dimension: traffic_source_satisfies_filter {
    type: yesno
    hidden: yes
    sql:  {% condition traffic_source_filter %} ${traffic_source} {% endcondition %} ;;
  }

  dimension: user_id {
    type: number
    # hidden: yes
    sql: ${TABLE}.user_id ;;
  }

  measure: count {
    type: count
    drill_fields: [id, users.id, users.first_name, users.last_name, order_items.count]
  }

  measure: count_dynamic_traffic_source {
    type: count
    filters: {
      field: traffic_source_satisfies_filter
      value: "yes"
    }
  }
}
