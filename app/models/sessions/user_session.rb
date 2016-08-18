module Sessions
  class UserSession < BaseSession
    EMPLOYEE_TYPE = 'Employee'.freeze

    def employee?
      extra_attributes && extra_attributes[:type] == EMPLOYEE_TYPE
    end
  end
end
