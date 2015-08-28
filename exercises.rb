require 'byebug'
class Employee
  attr_reader :salary, :name, :bonus, :boss, :employees

  def initialize(name, title, salary, boss)
    @name, @title, @salary, @boss = name, title, salary, boss
    boss.add_employee(self) if boss
    @employees = []
  end

  def bonus(multiplier)
    salary * multiplier
  end

end

class Manager < Employee
  attr_reader :employees, :boss, :salary
  def initialize(name, title, salary, boss)
    super(name, title, salary, boss)
    @employees = []
  end

  def add_employee(employee)
    @employees << employee
  end

  def bonus(multiplier)
    total_salary = total_all_employees_salaries
    # total_salary = employees.inject(0){ |accum, employee| accum + employee.salary}
    total_salary * multiplier
  end

  def total_all_employees_salaries
    total_salary = 0

    employees = self.employees
    until employees.empty?
      employee = employees.shift
      total_salary += employee.salary

      employees += employee.employees
    end
    total_salary
  end
end

ned = Manager.new("Ned", "Founder", 1000000, nil)
darren = Manager.new("Darren", "TA Manager", 78000, ned)
shawna = Employee.new("Shawna", "TA", 12000, darren)
david = Employee.new("David", "TA", 10000, darren)

p ned.bonus(5)
p darren.bonus(4) # => 88_000
p david.bonus(3) # => 30_000
