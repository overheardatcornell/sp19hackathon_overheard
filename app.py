import json
from db import db, Post, User, Comment
from flask import Flask, request

app = Flask(__name__)
db_filename = "backend.db"

app.config["SQLALCHEMY_DATABASE_URI"] = "sqlite:///%s" % db_filename
app.config["SQLALCHEMY_TRACK_MODIFICATIONS"] = False
app.config["SQLALCHEMY_ECHO"] = True

db.init_app(app)
with app.app_context():
    db.create_all()
@app.route("/posts/", methods=["GET"])
def get_all_posts():
#    posts = User.query.all()
    posts = Post.query.all()
    ps = {"success": True, "data": [p.serialize() for p in posts]}
    return json.dumps(ps), 201


@app.route("/user/<int:user_id>/post/", methods=["POST"])
def post_post(user_id):
    user = User.query.filter_by(id=user_id).first()
    if user is not None:
        post_body = json.loads(request.data)
        post = Post(
            title=post_body.get("title"),
            content=post_body.get("content"),
            username=post_body.get("username"),
            tags=post_body.get("tags"),
            user_id=post_body.get("user_id"),
        )
        user.posts.append(post)
        db.session.add(post)
        db.session.commit()
        return json.dumps({"success": True, "data": post.serialize()})
    return json.dumps({"success": False, "error": "User not found"}), 404


@app.route("/user/<int:user_id>/post/", methods=["GET"])
def get_posts(user_id):
    user = User.query.filter_by(id=user_id).first()
    if user is not None:
        post = [post.serialize() for post in user.posts]
        return json.dumps({"success": True, "data": post})
    return json.dumps({"success": False, "error": "User not found"}), 404


@app.route("/user/<int:user_id>/post/<int:post_id>/", methods=["GET", "DELETE"])
def get_del_post(user_id, post_id):
    user = User.query.filter_by(id=user_id).first()
    if user is not None:
        post = Post.query.filter_by(id=post_id).first()
        if post is not None:
            if request.method == "DELETE":
                db.session.delete(post)
                db.session.commit()
            return json.dumps({"success": True, "data": post.serialize()}), 200
        return json.dumps({"success": False, "error": "Post not found"}), 404
    return json.dumps({"success": False, "error": "User not found"}), 404


@app.route("/users/", methods=["POST"])
def create_user():
    user_body = json.loads(request.data)
    username = user_body.get("username")
    found = User.query.filter_by(username = username).first()
    if found is None:
        user = User(username=username)
        db.session.add(user)
        db.session.commit()
        return json.dumps({"success": True, "data": user.serialize()}), 201
#    return json.dumps({"success": False, "error": "User already found"}), 404
    return json.dumps({"success": True, "data": found.serialize()}), 202



@app.route("/users/", methods=["GET"])
def get_users():
    users = User.query.all()
    us = {"success": True, "data": [u.serialize() for u in users]}
    return json.dumps(us), 201


@app.route("/user/<int:user_id>/", methods=["GET"])
def get_user(user_id):
    user = User.query.filter_by(id=user_id).first()
    if user is not None:
        return json.dumps({"success": True, "data": user.serialize()}), 200
    else:
        return json.dumps({"success": False, "error": "User not found"}), 404


@app.route("/user/<int:user_id>/", methods=["DELETE"])
def del_user(user_id):
    user = User.query.filter_by(id=user_id).first()
    if user is not None:
        db.session.delete(user)
        db.session.commit()
        return json.dumps({"success": True, "data": user.serialize()}), 200
    else:
        return json.dumps({"success": False, "error": "User not found"}), 404


def have_user_like(x, y, z, e):
    optional_user = User.query.filter_by(id=y).first()
    optional_pc = Post.query.filter_by(id=x).first()
    if optional_user is None or optional_pc is None:
        return (
            json.dumps({"success": False, "error": str(z) + " or User not found"}),
            404,
        )
    if z == "Liked post/comment":
        if optional_pc.contains_user(optional_user):
            return (
                json.dumps({"success": False, "error": "User has already liked"}),
                404,
            )
    elif not (optional_pc.contains_user(optional_user)):
        return (
            json.dumps({"success": False, "error": "User has not already liked"}),
            404,
        )
    e(optional_pc, optional_user)
    db.session.add(optional_pc)
    db.session.commit()
    return (json.dumps({"success": True, "data": (optional_pc.serialize())}), 200)


@app.route("/post/<int:post_id>/<int:user_id>/like/", methods=["POST"])
def post_like(post_id, user_id):
    g = lambda x, y: (x.post_liked_by.append(y), x.inc_dec(1))
    return have_user_like(post_id, user_id, "Liked post/comment", g)


@app.route("/post/<int:post_id>/<int:user_id>/unlike/", methods=["POST"])
def post_unlike(post_id, user_id):
    g = lambda x, y: (x.post_liked_by.remove(y), x.inc_dec(-1))
    return have_user_like(post_id, user_id, "Unliked post/comment", g)


@app.route("/post/<int:post_id>/comments/", methods=["POST"])
def post_com(post_id):
    post = Post.query.filter_by(id=post_id).first()
    if post is not None:
        com_body = json.loads(request.data)
        com = Comment(
            content=com_body.get("content"),
            username=com_body.get("username"),
            post_id=post_id,
        )
        post.comments.append(com)
        db.session.add(com)
        db.session.commit()
        return json.dumps({"success": True, "data": com.serialize()})
    return json.dumps({"success": False, "error": "Post not found"}), 404


@app.route("/post/<int:post_id>/comments/", methods=["GET"])
def get_coms(post_id):
    post = Post.query.filter_by(id=post_id).first()
    if post is not None:
        com = [comment.serialize() for comment in post.comments]
        return json.dumps({"success": True, "data": com})
    return json.dumps({"success": False, "error": "Post not found"}), 404


@app.route("/post/<int:com_id>/<int:user_id>/like/", methods=["POST"])
def com_like(com_id, user_id):
    g = lambda x, y: (x.com_liked_by.append(y), x.inc_dec(1))
    return have_user_like(com_id, com_id, "Liked post/comment", g)


@app.route("/post/<int:com_id>/<int:user_id>/unlike/", methods=["POST"])
def com_unlike(com_id, user_id):
    g = lambda x, y: (x.com_liked_by.remove(y), x.inc_dec(-1))
    return have_user_like(com_id, user_id, "Unliked post/comment", g)


@app.route("/post/<int:post_id>/comment/<int:com_id>/", methods=["GET", "DELETE"])
def get_comment(post_id, com_id):
    post = Post.query.filter_by(id=post_id).first()
    if post is not None:
        com = Comment.query.filter_by(id=com_id).first()
        if com is not None:
            if request.method == "DELETE":
                db.session.delete(com)
                db.session.commit()
            return json.dumps({"success": True, "data": com.serialize()}), 200
        return json.dumps({"success": False, "error": "Comment not found"}), 404
    return json.dumps({"success": False, "error": "Post not found"}), 404


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000, debug=True)
