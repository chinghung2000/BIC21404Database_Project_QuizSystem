package com.project.backend;

import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class DatabaseManager {
	private Connection connection;
	private PreparedStatement pstmt;

	// constructor to receive database connection
	public DatabaseManager(Connection connection) {
		this.connection = connection;
	}

	// to prepare a SQL statement and bind respective parameters
	public boolean prepare(String statement, Object... parameters) {
		if (this.connection != null) {
			try {
				this.pstmt = this.connection.prepareStatement(statement, ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
				System.out.println("DatabaseManager.prepare: Preparing SQL statement: \"" + statement + "\"...");
				int i = 1;

				for (Object parameter : parameters) {
					if (parameter instanceof Boolean) {
						this.pstmt.setBoolean(i, (boolean) parameter);
					} else if (parameter instanceof Integer) {
						this.pstmt.setInt(i, (int) parameter);
					} else if (parameter instanceof Long) {
						this.pstmt.setLong(i, (long) parameter);
					} else if (parameter instanceof Float) {
						this.pstmt.setFloat(i, (float) parameter);
					} else if (parameter instanceof Double) {
						this.pstmt.setDouble(i, (double) parameter);
					} else if (parameter instanceof Character || parameter instanceof String) {
						this.pstmt.setString(i, (String) parameter);
					} else if (parameter instanceof Date) {
						this.pstmt.setDate(i, (Date) parameter);
					} else {
						this.pstmt.setNull(i, java.sql.Types.NULL);
					}

					i++;
				}

				return true;
			} catch (SQLException e) {
				System.out.println("DatabaseManager.prepare: There are some errors: " + e.toString());
			}
		} else {
			System.out.println("DatabaseManager.prepare: No database connection");
		}

		return false;
	}

	// to prepare a SQL statement and bind respective parameters for returning generated keys
	public boolean prepareForGeneratedKey(String statement, Object... parameters) {
		if (this.connection != null) {
			try {
				this.pstmt = this.connection.prepareStatement(statement, PreparedStatement.RETURN_GENERATED_KEYS);
				System.out.println("DatabaseManager.prepare: Preparing SQL statement: \"" + statement + "\"...");
				int i = 1;

				for (Object parameter : parameters) {
					if (parameter instanceof Boolean) {
						this.pstmt.setBoolean(i, (boolean) parameter);
					} else if (parameter instanceof Integer) {
						this.pstmt.setInt(i, (int) parameter);
					} else if (parameter instanceof Long) {
						this.pstmt.setLong(i, (long) parameter);
					} else if (parameter instanceof Float) {
						this.pstmt.setFloat(i, (float) parameter);
					} else if (parameter instanceof Double) {
						this.pstmt.setDouble(i, (double) parameter);
					} else if (parameter instanceof Character || parameter instanceof String) {
						this.pstmt.setString(i, (String) parameter);
					} else if (parameter instanceof Date) {
						this.pstmt.setDate(i, (Date) parameter);
					} else {
						this.pstmt.setNull(i, java.sql.Types.NULL);
					}

					i++;
				}

				return true;
			} catch (SQLException e) {
				System.out.println("DatabaseManager.prepare: There are some errors: " + e.toString());
			}
		} else {
			System.out.println("DatabaseManager.prepare: No database connection");
		}

		return false;
	}

	// to execute SQL statement with returning results
	public ResultSet executeQuery() {
		if (this.pstmt != null) {
			try {
				System.out.println("DatabaseManager.executeQuery: Executing prepared SQL statement...");
				ResultSet rs = this.pstmt.executeQuery();
				int rowCount = rs.last() ? rs.getRow() : 0;
				rs.beforeFirst();
				System.out.println("DatabaseManager.executeQuery: " + rowCount + " row(s) found.");
				return rs;
			} catch (SQLException e) {
				System.out.println("DatabaseManager.executeQuery: There are some errors: " + e.toString());
			}
		} else {
			System.out.println("DatabaseManager.executeQuery: No database connection");
		}

		return null;
	}

	// to execute SQL statement without returning result
	public boolean executeUpdate() {
		if (this.pstmt != null) {
			try {
				System.out.println("DatabaseManager.executeUpdate: Executing prepared SQL statement...");
				int affectedRowCount = this.pstmt.executeUpdate();
				System.out.println("DatabaseManager.executeUpdate: " + affectedRowCount + " row(s) affected.");
				return true;
			} catch (SQLException e) {
				System.out.println("DatabaseManager.executeUpdate: There are some errors: " + e.toString());
			}
		} else {
			System.out.println("DatabaseManager.executeUpdate: No database connection");
		}

		return false;
	}

	// to execute SQL statement without returning result for returning generated keys
	public ResultSet executeUpdateForGeneratedKey() {
		if (this.pstmt != null) {
			try {
				System.out.println("DatabaseManager.executeUpdate: Executing prepared SQL statement...");
				int affectedRowCount = this.pstmt.executeUpdate();
				System.out.println("DatabaseManager.executeUpdate: " + affectedRowCount + " row(s) affected.");
				
				return this.pstmt.getGeneratedKeys();
			} catch (SQLException e) {
				System.out.println("DatabaseManager.executeUpdate: There are some errors: " + e.toString());
			}
		} else {
			System.out.println("DatabaseManager.executeUpdate: No database connection");
		}

		return null;
	}

	// to close the database connection
	public boolean close() {
		if (this.connection != null) {
			try {
				this.connection.close();
				System.out.println("DatabaseManager.close: Database connection closed.");
				return true;
			} catch (SQLException e) {
				System.out.println("DatabaseManager.close: There are some errors: " + e.toString());
			}
		} else {
			System.out.println("DatabaseManager.close: No database connection");
		}

		return false;
	}
}
