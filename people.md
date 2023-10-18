---
title: People
layout: single
collection: people
---

| Name                   | Role       | Contact Address                                                   | Office Hours                   | Office Hours Location                   |
| {{ site.author.name }} | Instructor | [{{ site.author.emailaddr }}](mailto:{{ site.author.emailaddr }}) | {{ site.author.office_hours }} | {{ site.author.office_hours_location }} |
{% for person in site.data.personnel %} | {{ person.name }} | {{ person.role }} | [{{ person.email }}](mailto:{{ person.email }}) | {{ person.office_hours }} | {{ person.office_hours_location }} |
{% endfor %}

![Logical Distortion]({{ site.baseurl }}/assets/images/aura-of-logical-distortion.gif "Sometimes it helps just having someone else around")
