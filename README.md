# Jason Hemann 1114 Course Website

## Data

Filed under [./_data/](./_data) are information about:
- [personnel](./_data/personnel.yml) (including email and OH)
- [schedule](./_data/schedule.yml) 
  - Course schedule for lectures
  - "Out" dates for assignments
  - Pre-reading and pre-watch for lectures
  - Additional resources for material
- [navigation](./_data/navigation.yml) for linking material to the course website
- [assignment descriptions and starter code](./_starter_code/)
  This has the assignments from class, and starter code where appropriate.
  This information will be available as either a PDF or a .md file

## Schedule

[schedule.md](./schedule.md) contains the code for generating a schedule page from the above yml file.

This calculation makes several key assumptions, many of which do not generalize.
1. It assumes that the year starts on a Sunday
2. It assumes that a course starting in 202X ends in 202X; that is, a course does not extend into the next year. 
3. I believe it assumes that DST always begins on a Sunday, between weeks, and that the semester never starts *during* the Fall back.

## based on [Minimal Mistakes Jekyll theme](https://mmistakes.github.io/minimal-mistakes/)

