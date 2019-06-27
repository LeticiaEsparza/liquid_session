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

  dimension: user_id {
    type: number
    # hidden: yes
    sql: ${TABLE}.user_id ;;
  }

  # EXAMPLE 1 FOR LIQUID SESSION 2

  filter: traffic_source_filter {
    type: string
    suggest_dimension: orders.traffic_source
  }

  dimension: status_satisfies_source_filter {
    hidden: no
    type: yesno
    sql: {% condition traffic_source_filter %} ${traffic_source} {% endcondition %} ;;
  }

  measure: count_traffic_source {
    type: count
    filters: {
      field: status_satisfies_source_filter
      value: "yes"
    }
  }

  #END OF EXAMPLE 1

  measure: count {
    type: count
#     drill_fields: [id, users.id, users.first_name, users.last_name, order_items.count]
    html: {% if products.category._in_query and value >= 20000 %}
              <font color="green">{{rendered_value}}</font>
          {% elsif products.category._in_query and value >= 10000 and value < 20000 %}
              <font color="goldenrod">{{rendered_value}}</font>
          {% elsif products.category._in_query %}
              <font color="red">{{rendered_value}}</font>
          {% else %}
              {{rendered_value}}
          {% endif %}
    ;;
  }
}
