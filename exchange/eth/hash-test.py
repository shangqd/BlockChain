import hashlib

p1 = "b6103658b60234ade25b7389a08514b6803dff9c636dff92ef0edaa0f37e2eef"
sha256 = hashlib.sha256()
sha256.update(p1.decode('hex'))
res = sha256.hexdigest()
if res == "6872c4218185f506e8a5dd6dcc3c24a92f42bb61cd8ef4e80e621f703435f741":
    print("OK")
else:
    print("Err")

p1 = "6836ba9b8f40f968888a7376f657f97c53cfa8db02872e0f1daf8376cb80b1e7"
sha256 = hashlib.sha256()
sha256.update(p1.decode('hex'))
res = sha256.hexdigest()
if res == "c51a0b037d95fb20cc56339e4a8d16b69e93a1e5b62e8d496a21e07b2513a3df":
    print("OK")
else:
    print("Err")
