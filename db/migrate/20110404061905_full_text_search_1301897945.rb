class FullTextSearch1301897945 < ActiveRecord::Migration
  def self.up
    execute(<<-'eosql'.strip)
      DROP index IF EXISTS news_items_fts_idx
    eosql
    execute(<<-'eosql'.strip)
      CREATE index news_items_fts_idx
      ON news_items
      USING gin((to_tsvector('english', coalesce("news_items"."name", '') || ' ' || coalesce("news_items"."body", ''))))
    eosql
    execute(<<-'eosql'.strip)
      DROP index IF EXISTS pages_fts_idx
    eosql
    execute(<<-'eosql'.strip)
      CREATE index pages_fts_idx
      ON pages
      USING gin((to_tsvector('english', coalesce("pages"."name", '') || ' ' || coalesce("pages"."body", ''))))
    eosql
  end

  def self.down
    execute(<<-'eosql'.strip)
      DROP index IF EXISTS news_items_fts_idx
    eosql
    execute(<<-'eosql'.strip)
      DROP index IF EXISTS pages_fts_idx
    eosql
  end
end
