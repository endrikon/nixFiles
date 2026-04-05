{
  name,
  email,
}: {
  enable = true;
  settings = {
    user = {
      inherit name email;
    };
  };
}
