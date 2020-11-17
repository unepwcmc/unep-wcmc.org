### 0.3.11

* Small updates to job application form questions
* Confirmation emails now should be sent to iCloud accounts 

### 0.3.10

* ActionMailer set to use Sendmail over SMTP to allow confirmation emails to be sent to Gmail users 

### 0.3.9

* Make sure to delete the files attached to job application on destroy action.

### 0.3.8

* New Hotjar tracking code added 

### 0.3.7

* Fixed confirmation emails not being sent to candidates upon submitting their applications.

### 0.3.5

* Fix error with twitter share link

### 0.3.4

* Fix job application section accessibility
* Add link to annual review
* Fix user confirmation process

### 0.3.3

* Fix admin error on news tab

### 0.3.2

* Fix up styling on the /wcmc website
* Fix up styling on mailto buttons

### 0.3.1

* Temporarely hardcode statement to hide apply button for a submission
* Update robots.txt to allow Google to parse data for description in the search

### 0.3.0

**Add Proteus technical briefing note filter:**

* Added Proteus technical briefing note filter to resources and data


### 0.2.1

**CSV downloads for job applicant details:**

* Added email addresses for each job applicant into a CSV download.


### 0.1.2

**Job applications zipped downloads:**

* Added detailed logging for anticipation of fixing a bug which only appears on production.
* Fixed issue where application form is not provided, where download is now permitted.


### 0.1.1

**Job applications zipped downloads:**

* Fixed the length of job application document filenames for the `download_all_applications_zip` path.
* Fixed the consistency of the filenames across downloads.
* Reduced the length of the zip filenames.
* Bug fix for a bug which appears on staging within `application_generate_zip`.
* Bug fix to only generate a zip for all job applications if any of the submissions have valid attachments.
* Bug fix to handle file attachments which contain characters like `(` or `)` and thus including those files in the zip.


### 0.1.0

**Job applications zipped downloads:**

* Added `job_applications` controller and path,
* Zip file generation per job application and for all job applications,
* You must be logged in as a superadmin to access the new "Submitted job applications" link.
