from flask_wtf import FlaskForm
from wtforms import StringField, DateField, SubmitField, IntegerField
from wtforms.validators import DataRequired

class modify_plan_form(FlaskForm):
    in_course1 = StringField("Course 1")
    in_course2 = StringField("Course 2")
    in_course3 = StringField("Course 3")
    in_course4 = StringField("Course 4")
    in_course5 = StringField("Course 5")
    in_course6 = StringField("Course 6")
    in_course7 = StringField("Course 7")
    in_course8 = StringField("Course 8")
    addButton = SubmitField("Change")

    def getInputs(form):
        return [form['in_course1'], form['in_course2'], form['in_course3'], form['in_course4'], form['in_course5'], form['in_course6'], form['in_course7'], form['in_course8']]