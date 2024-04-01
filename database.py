#database.py

# 가상DB - 실제 DB 로직으로 대체해야함
def check_user_exists(user_id):
    # 여기서는 모든 ID가 존재한다고 가정
    return user_id in ["user1", "user2", "user3"]
