class Person
	def initialize(first_name, last_name)
		@first_name = first_name
		@last_name = last_name
	end
	def whoami
		@first_name + @last_name
	end
end

person = Person.new('Jouella', 'Fabe')
pp person.whoami
