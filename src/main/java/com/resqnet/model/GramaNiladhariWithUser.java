package com.resqnet.model;

public class GramaNiladhariWithUser {
    private User user;
    private GramaNiladhari gramaNiladhari;

    public GramaNiladhariWithUser() {}

    public GramaNiladhariWithUser(User user, GramaNiladhari gramaNiladhari) {
        this.user = user;
        this.gramaNiladhari = gramaNiladhari;
    }

    public User getUser() { return user; }
    public void setUser(User user) { this.user = user; }

    public GramaNiladhari getGramaNiladhari() { return gramaNiladhari; }
    public void setGramaNiladhari(GramaNiladhari gramaNiladhari) { this.gramaNiladhari = gramaNiladhari; }
}
