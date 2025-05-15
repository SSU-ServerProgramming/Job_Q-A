from ..common import db

def get_all_categories():
  conn = db.get_db_connection() 
  cursor = conn.cursor()
  
  sql = """
  SELECT 
      category_id,
      name
  FROM categories
  ORDER BY category_id
  """
  
  cursor.execute(sql)
  categories = cursor.fetchall()
  conn.close()
  
  return categories