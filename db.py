from flask_sqlalchemy import SQLAlchemy

db = SQLAlchemy()

user_post_relation = db.Table(
    "post_liked_by",
    db.Model.metadata,
    db.Column("user_id", db.Integer, db.ForeignKey("user.id")),
    db.Column("post_id", db.Integer, db.ForeignKey("post.id")),
)

user_comm_relation = db.Table(
    "com_liked_by",
    db.Model.metadata,
    db.Column("user_id", db.Integer, db.ForeignKey("user.id")),
    db.Column("comment_id", db.Integer, db.ForeignKey("comment.id")),
)


class User(db.Model):
    __tablename__ = "user"
    id = db.Column(db.Integer, primary_key=True)
    username = db.Column(db.String, nullable=False)
    user_liked = db.relationship(
        "Post", secondary=user_post_relation, back_populates="post_liked_by"
    )
    posts = db.relationship("Post", cascade="delete")

    def __init__(self, **kwargs):
        self.username = kwargs.get("username")

    def serialize(self):
        return {
            "id": self.id,
            "username": self.username,
            "user_liked": [l.small_serialize() for l in self.user_liked],
            "posts": [l.small_serialize() for l in self.posts],
        }


class Post(db.Model):
    __tablename__ = "post"
    id = db.Column(db.Integer, primary_key=True)
    likes = db.Column(db.Integer, nullable=False)
    username = db.Column(db.String, nullable=False)
    tags = db.Column(db.String, nullable=False)
    title = db.Column(db.String, nullable=False)
    content = db.Column(db.String, nullable=False)
    comments = db.relationship("Comment", cascade="delete")
    post_liked_by = db.relationship(
        "User", secondary=user_post_relation, back_populates="user_liked"
    )
    user_id = db.Column(db.Integer, db.ForeignKey("user.id"), nullable=False)

    def __init__(self, **kwargs):
        self.likes = 0
        self.content = kwargs.get("content")
        self.username = kwargs.get("username")
        self.tags = kwargs.get("tags")
        self.title = kwargs.get("title")
        self.post_id = kwargs.get("user_id")

    def inc_dec(self, value):
        self.likes += value

    def contains_user(self, user):
        return user in self.post_liked_by

    def serialize(self):
        return {
            "id": self.id,
            "likes": self.likes,
            "title": self.title,
            "liked_by": [l.serialize() for l in self.post_liked_by],
            # "comments": [c.serialize() for c in self.comments],
            "content": self.content,
            "username": self.username,
            "tags": self.tags,
        }

    def small_serialize(self):
        return {
            "id": self.id,
            "likes": self.likes,
            "title": self.title,
            # "comments": [c.serialize() for c in self.comments],
            "content": self.content,
            "username": self.username,
            "tags": self.tags,
        }


class Comment(db.Model):
    __tablename__ = "comment"
    id = db.Column(db.Integer, primary_key=True)
    likes = db.Column(db.Integer, nullable=False)
    content = db.Column(db.String, nullable=False)
    username = db.Column(db.String, nullable=False)
    com_liked_by = db.relationship("User", secondary=user_comm_relation)
    post_id = db.Column(db.Integer, db.ForeignKey("post.id"), nullable=False)

    def __init__(self, **kwargs):
        self.likes = 0
        self.content = kwargs.get("content")
        self.username = kwargs.get("username")
        self.post_id = kwargs.get("post_id")

    def inc_dec(self, value):
        self.likes += value

    def contains_user(self, user):
        return user in self.com_liked_by

    def serialize(self):
        return {
            "id": self.id,
            "username": self.username,
            "likes": self.likes,
            "liked_by": [c.serialize() for c in self.com_liked_by],
            "content": self.content,
            "username": self.username,
        }


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000, debug=True)
