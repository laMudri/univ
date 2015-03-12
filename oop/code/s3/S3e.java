package code.s3;

public class S3e {
    public static void main(String[] args) {
        User u0 = new User("u0");
        User u1 = new User("u1");

        u0.tweet("u0's first tweet");
        u1.follow(u0);
        u0.tweet("u0's second tweet");
        u1.tweet("u1's first tweet");
        u0.follow(u1);
        u1.tweet("u1's second tweet");
    }
}
