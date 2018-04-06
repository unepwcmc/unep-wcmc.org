### 0.1.1

**Job applications zipped downloads:**

* Fixed the length of job application document filenames for the `download_all_applications_zip` path.
* Fixed the consistency of the filenames across downloads.
* Reduced the length of the zip filenames.
* Bug fix for a bug which appears on staging within `application_generate_zip`.
* Bug fix to only generate a zip for all job applications if any of the submissions have valid attachments.
* Removed the regeneration of the zip for job applications when a submission is deleted.


### 0.1.0

**Job applications zipped downloads:**

* Added `job_applications` controller and path,
* Zip file generation per job application and for all job applications,
* You must be logged in as a superadmin to access the new "Submitted job applications" link.
