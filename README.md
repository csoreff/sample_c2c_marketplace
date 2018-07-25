# README

This API uses [devise\_token\_auth](https://devise-token-auth.gitbook.io/devise-token-auth/usage) for User registration and token authentication.

A user can be created like so:

```curl --data "email=test2@test.com&password=testpassword1&password_confirmation=testpassword1&confirm_success_url=http://localhost:3000" http://localhost:3000/auth```
