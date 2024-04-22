from flask import Flask, flash, render_template, url_for, request, redirect
import pandas as pd
import mysql.connector
import forms

app = Flask(__name__)
app.secret_key = 'teamMATS3112'

# ---- Global Variables ---- #

current_user = ""
current_semester = "Spring 2024"


# ---- Sets up local database connection ---- #

db_password = "password123"


def getdb():
    return mysql.connector.connect(
        host="localhost",
        user="root",
        password=db_password,
        database="schedulemse"
    )

# --- Site Page URLs --- #

@app.route("/")
def login():
    return render_template("login.html")

@app.route("/home")
def home():
    return render_template("home.html")

@app.route("/students")
def students():
    return render_template("students.html")

@app.route("/courses")
def courses():
    return render_template("courses.html")


# --- Site Routing Methods --- #

@app.route("/to_home", methods=['POST'])
def to_home():
    email = request.form['Email']
    password = request.form['Password']

    print(f"Attempted Login: {email} : {password}")

    mydb = getdb()
    cursor = mydb.cursor()

    try:
        print("Trying to go to home")

        query = f'''SELECT *
                    FROM admins
                    WHERE email='{email}'
                    AND password='{password}';'''
        cursor.execute(query)

        output = cursor.fetchall()
        print(output)
        print(len(output))

        if (len(output) == 0):
            flash('Login failed. Please check your credentials.', 'error')
            return redirect(url_for('login'))
        else:
            return redirect(url_for('home'))
        

    except mysql.connector.Error as err:
        print(err)

    finally:
        cursor.close()
        mydb.close()


@app.route("/to_students", methods=['GET'])
def to_students():
    mydb = getdb()
    cursor = mydb.cursor()

    try:
        query = f'''SELECT s.name, s.email, p.credit_hours, p.expected_graduation 
                    FROM students as s INNER JOIN plans as p 
                    ON s.id = p.student_id
                    WHERE p.semester LIKE '%{current_semester}%'
                    AND p.date_submitted IN
                        (SELECT MAX(date_submitted)
                        FROM students INNER JOIN plans 
                        ON students.id = plans.student_id
                        WHERE semester LIKE '%{current_semester}%'
                        GROUP BY plans.student_id
                        );'''
        cursor.execute(query)

        planned_students = cursor.fetchall()

        planned_columns = ['Name', 'Email', 'Credit Hours', 'Expected Graduation']

        query = f'''select s.name, s.email, IF(p.expected_graduation IS NOT NULL, p.expected_graduation, 'N/A') from students as s
                    left join plans as p
                    on s.id = p.student_id
                    where s.id NOT IN
                    (select p.student_id from plans as p,
                    (select MAX(date_submitted) as date_submitted, student_id
                    from plans
                    group by student_id) latest
                    where p.semester like '%{current_semester}%' 
                    and p.student_id = latest.student_id
                    and p.date_submitted = latest.date_submitted);'''
        cursor.execute(query)

        unplanned_students = cursor.fetchall()
        unplanned_columns = ['Name', 'Email', 'Expected Graduation']
        # Could not figure out good way to display dataframe
        # df = pd.DataFrame(output, columns=columns).reset_index(drop=True)
        return render_template("students.html", students_with_plans=planned_students, planned_fields=planned_columns, students_without_plans=unplanned_students, unplanned_fields=unplanned_columns)
        

    except mysql.connector.Error as err:
        print(err)

    finally:
        cursor.close()
        mydb.close()


@app.route("/to_courses", methods=['GET'])
def to_courses():
    mydb = getdb()
    cursor = mydb.cursor()

    try:
        print("Trying to go to courses")

        query = f'''SELECT id, credit_hours, 
                        (SELECT COUNT(*)
                        FROM plans
                        WHERE (course1=courses.id
                        OR course2=courses.id
                        OR course3=courses.id
                        OR course4=courses.id
                        OR course5=courses.id
                        OR course6=courses.id
                        OR course7=courses.id
                        OR course8=courses.id)
                        AND semester LIKE '%{current_semester}%'
                        AND plans.id IN
                            (SELECT MAX(id)
                            FROM plans
                            GROUP BY student_id, semester
                            HAVING MAX(date_submitted)
                            )
                        ) AS num_students,
                    capacity
                    FROM courses
                    WHERE semester LIKE '%{current_semester}%';'''
        cursor.execute(query)

        output = cursor.fetchall()
        print(output)

        columns = ['Course', 'Credit Hours', 'Expected Capacity', 'Max Capacity']
        print(columns)

        df = pd.DataFrame(output, columns=columns)
        return render_template("courses.html", courses = output, fields = columns)
    
    except mysql.connector.Error as err:
        print(err)

    finally:
        cursor.close()
        mydb.close()

# Individual student page
@app.route("/student/<student_name>", methods=['POST', 'GET'])
def student_page(student_name):
    mydb = getdb()
    cursor = mydb.cursor(dictionary=True)

    try:
        query = f'''select p.expected_graduation, p.date_submitted, p.semester, p.credit_hours, p.course1, p.course2, p.course3, p.course4, p.course5, p.course6, p.course7, p.course8 
                    from plans as p join students as s
                    on s.id = p.student_id
                    where s.name like '%{student_name}%'
                    order by p.date_submitted DESC;'''
        cursor.execute(query)
        output = cursor.fetchall()
        columns = ['Expected Graduation', 'Date Submitted', 'Semester', 'Credits', 'Course 1', 'Course 2', 'Course 3', 'Course 4', 'Course 5', 'Course 6', 'Course 7', 'Course 8']
        return render_template("student_plans.html", name=student_name, plans=output, fields=columns)

    except mysql.connector.Error as err:
        print(err)
    finally:
        cursor.close()
        mydb.close()

@app.route("/plan/<student_name>+<semester>", methods=['POST', 'GET'])
def modify_plan(student_name, semester):
    mydb = getdb()

    try:
        form = getattr(forms, 'modify_plan_form')()
        if request.method == 'POST':
            cursor = mydb.cursor()
            inputs = getattr(forms, 'modify_plan_form').getInputs(request.form)
            inputs.insert(0, semester)
            query = f'''select id from student where name like %{student_name}%'''
            student_id = cursor.execute(query).fetchall()
            inputs.insert(0, student_id)
            print(str(student_id))
            print(str(inputs))
            cursor.callproc('modify_plan', inputs)
            mydb.commit()
            cursor.close()
            return redirect(app.last_page)
    finally:
        mydb.close()

    return render_template('modify_plan.html', name=student_name, plan_semester=semester, form=form)
            
# --- Run Application --- #

app.run(debug=True, port=5001)
