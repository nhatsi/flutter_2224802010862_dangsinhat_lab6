using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace WebApiWithRoleAuthentication.Migrations
{
    /// <inheritdoc />
    public partial class UpdateAdminAccount : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DeleteData(
                table: "AspNetUserRoles",
                keyColumns: new[] { "RoleId", "UserId" },
                keyValues: new object[] { "1", "d94d6451-d159-47e8-87ed-a0ccdc87dcb6" });

            migrationBuilder.DeleteData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "d94d6451-d159-47e8-87ed-a0ccdc87dcb6");

            migrationBuilder.InsertData(
                table: "AspNetUsers",
                columns: new[] { "Id", "AccessFailedCount", "ConcurrencyStamp", "Email", "EmailConfirmed", "LockoutEnabled", "LockoutEnd", "NormalizedEmail", "NormalizedUserName", "PasswordHash", "PhoneNumber", "PhoneNumberConfirmed", "SecurityStamp", "TwoFactorEnabled", "UserName" },
                values: new object[] { "admin-user-id-001", 0, "admin-concurrency-stamp-001", "admin@gmail.com", true, false, null, "ADMIN@GMAIL.COM", "ADMIN", "AQAAAAIAAYagAAAAEFwGh7pd/PEK1URZCEhA69LrrFnUvDc+CSuEkyT+uoHrO2qFLs6AswEEH/MmLg66/g==", "1234567890", true, "admin-security-stamp-001", false, "admin" });

            migrationBuilder.InsertData(
                table: "AspNetUserRoles",
                columns: new[] { "RoleId", "UserId" },
                values: new object[] { "1", "admin-user-id-001" });
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DeleteData(
                table: "AspNetUserRoles",
                keyColumns: new[] { "RoleId", "UserId" },
                keyValues: new object[] { "1", "admin-user-id-001" });

            migrationBuilder.DeleteData(
                table: "AspNetUsers",
                keyColumn: "Id",
                keyValue: "admin-user-id-001");

            migrationBuilder.InsertData(
                table: "AspNetUsers",
                columns: new[] { "Id", "AccessFailedCount", "ConcurrencyStamp", "Email", "EmailConfirmed", "LockoutEnabled", "LockoutEnd", "NormalizedEmail", "NormalizedUserName", "PasswordHash", "PhoneNumber", "PhoneNumberConfirmed", "SecurityStamp", "TwoFactorEnabled", "UserName" },
                values: new object[] { "d94d6451-d159-47e8-87ed-a0ccdc87dcb6", 0, "521b9b83-3d0d-4f95-8da5-4c35ae379e9c", "freetrained@freetrained.com", true, false, null, "FREETRAINED@FREETRAINED.COM", "FREETRAINED@FREETRAINED.COM", "AQAAAAIAAYagAAAAEBx03SPRMcNxzketnW+if2YLK11PJ9bgSBW8VFCxVDbWmv1UG6Te2rMxEJP9L8kLYA==", "1234567890", true, "9d019822-7890-44ca-84e4-c19ff695a456", false, "freetrained@freetrained.com" });

            migrationBuilder.InsertData(
                table: "AspNetUserRoles",
                columns: new[] { "RoleId", "UserId" },
                values: new object[] { "1", "d94d6451-d159-47e8-87ed-a0ccdc87dcb6" });
        }
    }
}
