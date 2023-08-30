---
title: Schedule 
layout: single
classes: wide
---
{% assign start_date_unix = site.data.schedule.semester_start | date: "%s" %}
{% assign days = "M,T,W,R,F,Sa,Su" | split: "," %}
{% for week in site.data.schedule.weeks %}
<details>
  {% assign week_seconds = week.week_offset | times: 604800 %}
  {% assign start_unix = start_date_unix | plus: week_seconds %}
  {% assign end_unix = start_unix | plus: 518400 %} <!-- Add 6 days to start date to get end date -->
  <summary><strong>{{ start_unix | date: '%b %d' }} - {{ end_unix | date: '%b %d' }}</strong></summary>
  <ul>
  <li><strong>Assignments:</strong>
	<ul>
	  {% for hw in week.homework %}
{% assign out_day_offset = -1 %}
{% for day in days %}
  {% if day == hw.out %}
    {% assign out_day_offset = forloop.index0 %}
    {% break %}
  {% endif %}
{% endfor %}
      {% assign out_day_offset_seconds = out_day_offset | times: 86400 %}
      {% assign out_day_seconds = start_unix | plus: out_day_offset_seconds %}
	  <li><strong>{{ hw.title }}:</strong> Assigned on {{ out_day_seconds | date: '%a, %b %d' }}{% if hw.starter_code %} | <a href="https://github.com/jasonhemann/23FA-CS1114/tree/master/_starter_code/{{ hw.starter_code }}">Starter Code</a>{% endif %}</li>
      {% endfor %}
	</ul>
 </li>
  {% for session in week.sessions %}
  {% assign day_offset = days | index: session.day %}
  {% assign day_seconds = session.day | times: 86400 %}
  {% assign session_unix = start_date_unix | plus: week_seconds | plus: day_seconds %}
  {% assign session_date = session_unix | date: '%a, %b %d' %}
  <li><strong>{{ session_date }} Lecture: {{session.title}} </strong>
    <ul>
      <li><strong>Topics:</strong>
        <ul>
          {% for topic in session.topics %}
		  <li> {{ topic.desc }} </li>
		  {% endfor %}
		</ul>
      </li>
      <li><strong>Preparation:</strong>
        <ul>
		  {% for reading in session.pre_readings %}
			<li>
			  📖 
			  {% if reading.link %}
				<a href="{{ reading.link }}">{{ reading.title }}</a>
			  {% else %}
				{{ reading.title }}
			  {% endif %}
			</li>
		  {% endfor %}
          {% for video in session.videos %}
          <li>🎥 <a href="{{ video.link }}">{{ video.title }}</a></li>
          {% endfor %}
        </ul>
      </li>
      <li><strong>Extra Resources:</strong>
        <ul>
		  {% for resource in session.extra_resources %}
			<li>
			  {% if resource.link %}
				<a href="{{ resource.link }}">{{ resource.title }}</a>
			  {% else %}
				{{ resource.title }}
			  {% endif %}
			</li>
		  {% endfor %}
        </ul>
      </li>
    </ul>
  </li>
  {% endfor %}
  </ul>
</details>
{% endfor %}


