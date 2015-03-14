module ApplicationHelper
  def render_jbuilder partial, opts
    render_to_string(
      partial: partial,
      locals: opts
    ).html_safe
  end
end
