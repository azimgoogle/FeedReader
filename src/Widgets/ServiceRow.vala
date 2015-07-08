public class FeedReader.ServiceRow : baseRow {

	private string m_name;
    private OAuth m_type;
    private Gtk.Label m_label;
    private Gtk.Box m_box;
	private Gtk.Stack m_stack;
    private Gtk.Button m_login_button;

	public ServiceRow(string serviceName, OAuth type)
	{
		m_name = serviceName;
        m_type = type;
		m_stack = new Gtk.Stack();
		string iconPath = "";
		GLib.Settings serviceSettings = settings_readability;

        m_login_button = new Gtk.Button.with_label(_("Login"));
        m_login_button.hexpand = false;
        m_login_button.margin = 10;
        m_login_button.clicked.connect(() => {
			share.getRequestToken(type);

            var dialog = new LoginDialog(type);
			dialog.sucess.connect(() => {
				share.getAccessToken(type);
				m_stack.set_visible_child_name("loggedIN");
			});
        });

		var loggedIN = new Gtk.Image.from_icon_name("dialog-apply", Gtk.IconSize.LARGE_TOOLBAR);

		m_stack.add_named(m_login_button, "button");
		m_stack.add_named(loggedIN, "loggedIN");

		m_box = new Gtk.Box(Gtk.Orientation.HORIZONTAL, 0);
		m_box.set_size_request(0, 50);

		switch (m_type)
        {
            case OAuth.READABILITY:
                iconPath = "/usr/share/FeedReader/readability.svg";
				serviceSettings = settings_readability;
                break;

            case OAuth.INSTAPAPER:
                iconPath = "/usr/share/FeedReader/instapaper.svg";
                break;

            case OAuth.POCKET:
                iconPath = "/usr/share/FeedReader/pocket.svg";
				serviceSettings = settings_pocket;
                break;
        }

        var icon = new Gtk.Image.from_file(iconPath);

		m_label = new Gtk.Label(m_name);
		m_label.set_line_wrap_mode(Pango.WrapMode.WORD);
		m_label.set_ellipsize(Pango.EllipsizeMode.END);
		m_label.set_alignment(0.5f, 0.5f);

		m_box.pack_start(icon, false, false, 8);
		m_box.pack_start(m_label, true, true, 0);
        m_box.pack_end(m_stack, false, false, 0);

		var seperator_box = new Gtk.Box(Gtk.Orientation.VERTICAL, 0);
		var separator = new Gtk.Separator(Gtk.Orientation.HORIZONTAL);
		separator.set_size_request(0, 2);
		seperator_box.pack_start(m_box, true, true, 0);
		seperator_box.pack_start(separator, false, false, 0);

		this.add(seperator_box);
		this.show_all();

		if(serviceSettings.get_boolean("is-logged-in"))
		{
			m_stack.set_visible_child_name("loggedIN");
		}
		else
		{
			m_stack.set_visible_child_name("button");
		}
	}

}
