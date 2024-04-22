# Team MATS
## Our Project - MSE Scheduling Optimization

   The materials science and engineering undergraduate program requires a variety of courses that every student must take. Due to scheduling reasons, these courses usually have only one section taught per semester. This has created difficulties for MSE advisors and schedule planners to perform their jobs to help students stay on track in their curriculum progression and to plan optimal section schedules that work well for as many students as possible.  

   Therefore, our solution provides MSE advisors and schedule planners with an application that considers semester course plans submitted by MSE students, stores and analyzes this information, and presents it to MSE staff to perform their jobs. Access the MSE Scheduling Optimization site at https://schedule.mse.gatech.edu/.

## Jira Board
   https://jib-3112-mats.atlassian.net/

## License Info - Apache License 2.0

   With the Apache License 2.0 for our software, we hold a permissive license that allows us to keep our software open source with the assurance of patent protection. The code may be reused and modified by developers while also ensuring that we, as the original authors, must be referenced and cannot be held legally liable.

## Release Notes

### Version 0.4.0

#### Features
* Redesigned UI for a more cohesive style and improved user-friendliness.
* Users can modify information about a student and their course plans, with updates reflected in the database.

#### Bug Fixes
* The site would crash when trying to populate the students page table with data from the database. This issue has now been resolved, and student data from the database can be used for the students page.

#### Known Issues
* The form page for modifying a student's plan does not properly load its associated CSS, resulting in an improper UI appearance.
* Navbar functions, including Home, Admin, Semester, and Search features, are non-functional.
* Hosting for the website and database still is not functional. Deploying the code hasn't yet worked.

---

### Version 0.3.0

#### Features
* A user can access an individual student page to view their plan information.

#### Bug Fixes
N/A

#### Known Issues
* The site code cannot be deployed to a server yet to host on a domain.
* The database can only be accessed on the local machine.

---

### Version 0.2.0

#### Features
* People and courses tab has been implemented.
* UI and UX has been updated for the home page.

#### Bug Fixes
N/A

#### Known Issues
* Deploying code to the server can be complicated and problematic.
* Server configuration on the deployed website is troublesome.

---

### Version 0.1.0

#### Features
* Students can complete a Canvas quiz detailing their course plans for multiple semesters.
* A quiz submission report can be generated containing all relevant information about MSE students and their course plans.

#### Bug Fixes
N/A

#### Known Issues
* The Canvas quiz cannot be easily modified as it is currently configured. This will make it difficult to accomodate changing course information in the future.
* The quiz submission report cannot be generated automatically, meaning that MSE faculty will have to repeatedly access Canvas each time an updated report is needed.

---

## Install Guide
This is a step-by-step guide to install and run the applicaiton locally on ones device. First and foremost, here are some of the items needed to have installed on one's computer:
- Python (Any Version 3 but Version 3.11 preferably)
- Pip
- MySQLWorkbench
- Text editor (VS Code Recommended)

First, begin by cloning this repository to your machine in a location of your choice. Once cloned, you can open the folder in the text editor of your choice to see all of the files. The first file we will address is *ScheduleMSE.sql*. After installing MySQLWorkbench, open it up and create a new MySQL connection to use for the local database for this application. Log in to the instance using your username and password and remember the password you use. Then, open *ScheduleMSE.sql* in your MySQLWorkbench conneciton and run the file using the lightning icon. This will create the schema for the application database in the instance. From here, you can view tables and examine the data stored.

Next, we want to return to our text editor and see the files. The most important file is *app.py* which we use to launch the application. Open *app.py* and find the commented section that says "Sets up local database connection". Here, you will put your connection password from earlier in the variable called db_password. Please make sure that the information in the getdb() method below is variable is also correct before running.

Once you have setup the local instance of your database, we must ensure that you are able to run the Python virtual environment containing all of the packages used in the application. Using the command terminal on your machine (or in the text editor is using VS Code), navigate to the folder of the application. Once in the folder, you can first check your Python and Pip versions by running the following two commands:
- python -V or python --version
- pip -V or pip --version

Once you have confirmed that you have Python and Pip installed, you must run the virtual environment. Here is the command to run:
- Mac OS: source env/bin/activate
- Windows: ##NEED TO FILL THIS IN

You know the virtual environment is running when it pops up on the left side of your command line! Now you are ready to run the application! In your terminal with the virtual environment activated, run the command:
- python app.py

This should then load a message into the terminal with the local site url which you can copy into your web browser to access the application.
To deactivate and close the application, do CTRL+C in the terminal to quit app.py and then input the command "deactivate" to deactivate the virtual environment.
