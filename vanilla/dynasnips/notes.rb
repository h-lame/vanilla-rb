require 'vanilla/dynasnip'

class Notes < Dynasnip
  def get(*args)
    all_notes_content = all_notes.map { |snip| 
      render_note(snip) 
    }.join("")
    notes_snip.main_template.
      gsub('[notes]', all_notes_content)
  end

  def post(*args)
    new_note = Snip.new(cleaned_params)
    new_note.name = "note_#{notes_snip.next_note_id}"
    new_note.kind = "note"
    new_note.save
    increment_next_id
    get(*args)
  end
  
  private 
  
  def notes_snip
    Snip['notes']
  end
  
  def all_notes
    Snip.with(:kind, "= 'note'")
  end
  
  def increment_next_id
    s = notes_snip
    s.next_note_id = s.next_note_id.to_i + 1
    s.save
  end

  def render_note(snip)
    note_link = Vanilla::Routes.link_to(snip.name)
    note_content = Vanilla.render(snip.name, nil, context, [])
    notes_snip.note_template.gsub('[note]', note_content).gsub('[link]', note_link)
  end
  
  attribute :next_note_id, 1
  
  attribute :note_template, %{<dt>[link]</dt><dd>[note]</dd>}
  attribute :main_template, %{<dl>[notes]</dl>}
end