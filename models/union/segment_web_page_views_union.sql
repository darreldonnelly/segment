{% set sources = ['segment_studio_page_views_table','segment_premiumbeat_page_views_table'] %}

{% set common_columns = ['id','anonymous_id','user_id','received_at','sent_at','timestamp','url','path','title','search','referrer','context_campaign_source','context_campaign_medium','context_campaign_name','context_campaign_term','context_campaign_content','context_ip','context_user_agent', 'page_site', 'page_page_type'] %}

with source_union as (

{% for source in sources %}
    select
        {% for col in common_columns %}
        {{ col }} {% if not loop.last -%},{%- endif %}
        {% endfor %}
    from {{var(source)}}
{% if not loop.last -%} union all {%- endif %}
{% endfor %}

)

--- Temporarily restrict this to a short time period until we're happy
select * from source_union
where received_at     > DATE('2020-07-01')
