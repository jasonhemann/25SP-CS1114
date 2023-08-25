---
title: Schedule 
layout: single
classes: wide
---
{% assign start_date_unix = site.data.schedule.semester_start | date: "%s" %}
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
	  <li><strong>{{ hw.title }}:</strong> Assigned on {{ hw.out }}</li>
	  {% endfor %}
	</ul>
 </li>
  {% for session in week.sessions %}
  {% assign day_seconds = session.day_offset | times: 86400 %}
  {% assign session_unix = start_date_unix | plus: week_seconds | plus: day_seconds %}
  {% assign session_date = session_unix | date: '%m-%d' %}
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
          <li>📖 <a href="{{ reading.link }}">{{ reading.title }}</a></li>
          {% endfor %}
          {% for video in session.videos %}
          <li>🎥 <a href="{{ video.link }}">{{ video.title }}</a></li>
          {% endfor %}
        </ul>
      </li>
      <li><strong>Extra Resources:</strong>
        <ul>
          {% for resource in session.extra_resources %}
          <li><a href="{{ resource.link }}">{{ resource.title }}</a></li>
          {% endfor %}
        </ul>
      </li>
    </ul>
  </li>
  {% endfor %}
  </ul>
</details>
{% endfor %}


