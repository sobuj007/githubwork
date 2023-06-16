class Api{

  getuserInfo(c)=>"https://api.github.com/users/$c".toString();
  getRepoInfo(c)=>"https://api.github.com/users/$c/repos".toString();
}