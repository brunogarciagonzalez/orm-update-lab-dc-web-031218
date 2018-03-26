require_relative "../config/environment.rb"
require "pry"
class Student

  # Remember, you can access your database connection anywhere in this class
  #  with DB[:conn]
  attr_accessor :name, :grade
  attr_reader :id

  def initialize(id = nil, name, grade)
    @name = name
    @grade = grade
    @id = id
  end

  def self.create_table
    #  creates the students table in the database
    sql = "create table students(id integer primary key, name text, grade integer);"
    DB[:conn].execute(sql)
  end

  def self.drop_table
    #  drops the students table from the database
    sql = "drop table if exists students;"
    DB[:conn].execute(sql)
  end

  def self.create(id = nil, name, grade)
    # creates a student object with name and grade attributes
    new_student = self.new(id, name, grade)
    new_student.save
    new_student
  end

  def self.new_from_db(row)
    # creates an instance with corresponding attribute values
    new_student = self.new(row[0], row[1], row[2])
    new_student
    # binding.pry
  end

  def self.find_by_name(name)
    # returns an instance of student that matches the name from the DB
    sql = "select * from students where name = (?);"
    student_row = DB[:conn].execute(sql, name)[0]
    new_from_db(student_row)
  end

  def save
    # saves an instance of the Student class to the database and then sets the given students `id` attribute
    # updates a record if called on an object that is already persisted
    if self.id
      sql = "update students set name = ?, grade = ? where id = ?;"
      DB[:conn].execute(sql, self.name, self.grade, self.id)
    else
      sql = <<-SQL
        INSERT INTO students (name, grade)
        VALUES (?, ?)
      SQL
      DB[:conn].execute(sql, self.name, self.grade)
      @id = DB[:conn].execute("select last_insert_rowid() from students")[0][0]
    end
  end

  def update
    # updates the record associated with a given instance
    self.save
    # ????? this method has half of the functionality of #save
  end
end
