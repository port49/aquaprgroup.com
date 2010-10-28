class AvmGroup < Dictionary
  populate [
      {:name => 'Creator'},
      {:name => 'Content'},
      {:name => 'Observation'},
      {:name => 'Coordinate'},
      {:name => 'Publisher'}
    ]

  def avm_elements
    AvmElement.all.select{|avm| avm.avm_group_id == self.id}
  end

end

