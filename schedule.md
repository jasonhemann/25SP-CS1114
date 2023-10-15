---
title: Schedule
layout: single
classes: wide
---
<!-- Constants -->
{% assign days = "M,T,W,R,F,Sa,Su" | split: "," %}
{% assign SECONDS_PER_DAY = 86400 %}
{% assign DAYS_IN_WEEK = 7 %}
{% assign SECONDS_PER_WEEK = SECONDS_PER_DAY | times: DAYS_IN_WEEK %}
{% assign SATURDAY_SECONDS_OFFSET = SECONDS_PER_DAY | times: 6 %}
<!-- https://www.epochconverter.com/weeks/202X -->
{% assign semester_start_seconds = site.data.schedule.semester_start | date: "%s" %}
{% assign semester_start_week = site.data.schedule.semester_start_week %}
{% assign dst_start_week = site.data.schedule.dst_start_week %}
{% assign dst_end_week = site.data.schedule.dst_end_week %}

{% for week in site.data.schedule.weeks %}
<details>
{% assign week_start_seconds =  week.week_offset | times: SECONDS_PER_WEEK | plus: semester_start_seconds %}
{% assign week_num = week.week_offset | plus: semester_start_week %}
<!-- If |---StartDST--StartSemester--EndDST--Current-Week--| -->
{% if semester_start_week < dst_end_week and dst_end_week < week_num %}
	{% assign week_start_seconds = week_start_seconds | plus: 3600 %}
<!-- If |--StartSemester--StartDST--Current-Week--EndDST--| -->
{% elsif dst_start_week < semester_start_week and week_num < dst_end_timestamp %}
	{% assign week_start_seconds = week_start_seconds | minus: 3600 %}
{% endif %}
{% assign week_end_seconds = week_start_seconds | plus: SATURDAY_SECONDS_OFFSET %}

 <summary><strong>{{ week_start_seconds | date: "%b-%d" }} - {{ week_end_seconds | date: "%b-%d" }} </strong></summary>
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
	  {% assign out_day_seconds = out_day_offset | times: SECONDS_PER_DAY | plus: week_start_seconds %}
	  <li><strong>{{ hw.title }}:</strong> Assigned on {{ out_day_seconds | date: '%a, %b %d' }} {% if hw.starter_code %} | <a href="{{ site.sourceurl }}{{ site.baseurl }}/tree/master/_starter_code/{{ hw.starter_code }}">Starter Code</a>{% endif %}</li>
	  {% endfor %}
	</ul>
 </li>
  {% for session in week.sessions %}
  {% assign out_day_offset = -1 %}
  {% for day in days %}
	{% if day == session.day %}
	  {% assign session_day_offset = forloop.index0 %}
	  {% break %}
	{% endif %}
  {% endfor %}
  {% assign session_seconds = session_day_offset | times: SECONDS_PER_DAY | plus: week_start_seconds %}
  <li><strong>{{ session_seconds | date: '%a, %b %d' }} Lecture: {{session.title}} </strong>
	<ul>
	  {% if session.topics.size > 0 %}
	  <li><strong>Topics:</strong>
		<ul>
		  {% for topic in session.topics %}
		  <li> {{ topic.desc }} </li>
		  {% endfor %}
		</ul>
	  </li>
	  {% endif %}
  	  {% if session.pre_readings.size + session.videos.size > 0 %}
	  <li><strong>Preparation:</strong>
		<ul>
	  	  {% if session.pre_readings.size > 0 %}
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
		  {% endif %}
	  	  {% if session.videos.size > 0 %}
			{% for video in session.videos %}
			<li>🎥 <a href="{{ video.link }}">{{ video.title }}</a></li>
			{% endfor %}
		  {% endif %}
		</ul>
	  </li>
	  {% endif %}
	  {% if session.extra_resources.size > 0 %}
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
	  {% endif %}
	</ul>
  </li>
  {% endfor %}
  </ul>
</details>
{% endfor %}
