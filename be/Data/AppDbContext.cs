using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Identity.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore;

namespace WebApiWithRoleAuthentication.Data
{
    public class AppDbContext : IdentityDbContext<IdentityUser>
    {
        public AppDbContext(DbContextOptions options) : base(options)
        {
        }

        protected override void OnModelCreating(ModelBuilder builder)
        {
            base.OnModelCreating(builder);

            // Seed Roles
            builder.Entity<IdentityRole>().HasData(
                new IdentityRole
                {
                    Id = "1",
                    Name = "Admin",
                    NormalizedName = "ADMIN"
                },
                new IdentityRole
                {
                    Id = "2",
                    Name = "User",
                    NormalizedName = "USER"
                }
            );

            // Seed Admin Data
            var hasher = new PasswordHasher<IdentityUser>();

            var adminUser = new IdentityUser
            {
                Id = "d94d6451-d159-47e8-87ed-a0ccdc87dcb6",
                UserName = "sinhat@gmail.com",
                NormalizedUserName = "SINHAT@GMAIL.COM",
                Email = "sinhat@gmail.com",
                NormalizedEmail = "SINHAT@GMAIL.COM",
                PhoneNumber = "1234567890",
                EmailConfirmed = true,
                PhoneNumberConfirmed = true,
                LockoutEnabled = false,
                SecurityStamp = "9d019822-7890-44ca-84e4-c19ff695a456",
                ConcurrencyStamp = "521b9b83-3d0d-4f95-8da5-4c35ae379e9c"
            };

            adminUser.PasswordHash = hasher.HashPassword(adminUser, "sinhat123");

            builder.Entity<IdentityUser>().HasData(adminUser);

            // Assign Role To Admin
            builder.Entity<IdentityUserRole<string>>().HasData(
                new IdentityUserRole<string>
                {
                    RoleId = "1",
                    UserId = adminUser.Id
                }
            );
        }
    }
}