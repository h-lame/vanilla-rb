dynasnip "notes", %{
  class Notes < Dynasnip
    def get(*args)
      all_notes(true).map { |snip| render_note(snip) }
    end
    def post(*args)
      new_note = Snip.new(cleaned_params)
      new_note.name = "note_\#{notes_snip.next_note_id}"
      new_note.kind = "note"
      new_note.save
      increment_next_id
      get(*args)
    end
    
    private 
    
    def notes_snip
      Snip['notes']
    end
    
    def all_notes(reload=false)
      @all_notes = nil if reload
      @all_notes ||= Snip.with(:kind, "= 'note'")
    end
    
    def increment_next_id
      s = notes_snip
      s.next_note_id = s.next_note_id.to_i + 1
      s.save
    end

    def render_note(snip)
      "<div class='note'>" + Vanilla::Routes.link_to(snip.name) + Render.render(snip.name, nil, context, []) + "</div>"
    end
  end
  Notes
}, :next_note_id => 1, :render_as => "Ruby"