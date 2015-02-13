module SettingsHelper
  def action_button(user)
    return "<button class='user-delete-button' data-userid='#{user.id}'>Delete</button>".html_safe if session[:priv_level] > user.priv_level
  end

  def post_with_checkboxes
    @params = request.POST.dup

    add_checkbox_entries_for_section("quotes")
    add_checkbox_entries_for_section("sales_invoices")
    add_checkbox_entries_for_section("suppliers_pop")
    add_checkbox_entries_for_section("subcontractors_pop")
    return @params
  end

  def add_checkbox_entries_for_section(name)
    @params["#{name}_to_1"] = 0
    @params["#{name}_to_1"] = 1 if request.POST["#{name}_to_1"] == "on"

    @params["#{name}_to_2"] = 0
    @params["#{name}_to_2"] = 1 if request.POST["#{name}_to_2"] == "on"

    @params["#{name}_to_3"] = 0
    @params["#{name}_to_3"] = 1 if request.POST["#{name}_to_3"] == "on"
  end
end
