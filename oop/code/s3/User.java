package code.s3;

import java.util.LinkedList;

public class User {
    private LinkedList<User> mFollowers = new LinkedList<>();
    private String mName;

    public User(String name) {
        mName = name;
    }

    public String getName() { return mName; }

    public void tweet(String msg) {
        System.out.println(mName + " tweeted: " + msg);
        for (User u : mFollowers)
            u.notify(msg);
    }

    public void follow(User user) {
        System.out.println(mName + " followed " + user.getName());
        user.registerFollower(this);
    }

    public void registerFollower(User user) {
        mFollowers.add(user);
    }

    public void notify(String msg) {
        System.out.println(mName + " received: " + msg);
    }
}
