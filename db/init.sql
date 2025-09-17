-- 研究主题表
CREATE TABLE research_topics (
    id SERIAL PRIMARY KEY,
    name TEXT NOT NULL UNIQUE,
    description TEXT
);

-- 通用标签表（标签系统）
CREATE TABLE tags (
    id SERIAL PRIMARY KEY,
    name TEXT NOT NULL UNIQUE
);

-- Source 文献，包括互联网上的原始文献信息
CREATE TABLE source_documents (
    id SERIAL PRIMARY KEY,
    title TEXT NOT NULL,
    author TEXT,
    publication_date DATE, -- 文献发表时间，或知识库收录的时间
    language TEXT,
    description TEXT,
    url TEXT
);

-- 文献章节（通过 tag_id 支持分类）
CREATE TABLE source_sections (
    id SERIAL PRIMARY KEY,
    document_id INTEGER REFERENCES source_documents(id) ON DELETE CASCADE,
    tag_id INTEGER REFERENCES tags(id) ON DELETE SET NULL,
    section_title TEXT,
    content TEXT NOT NULL,
    section_number INTEGER,
    created_at TIMESTAMP DEFAULT NOW()
);


-- 研究主题与标签的关联表
CREATE TABLE research_topic_tags (
    research_topic_id INTEGER REFERENCES research_topics(id) ON DELETE CASCADE,
    tag_id INTEGER REFERENCES tags(id) ON DELETE CASCADE,
    PRIMARY KEY (research_topic_id, tag_id)
);

-- 研究主题与文献章节的关联表
CREATE TABLE research_topic_sections (
    research_topic_id INTEGER REFERENCES research_topics(id) ON DELETE CASCADE,
    section_id INTEGER REFERENCES source_sections(id) ON DELETE CASCADE,
    PRIMARY KEY (research_topic_id, section_id)
);

-- 文献章节与标签的关联表
CREATE TABLE section_tags (
    section_id INTEGER REFERENCES source_sections(id) ON DELETE CASCADE,
    tag_id INTEGER REFERENCES tags(id) ON DELETE CASCADE,
    PRIMARY KEY (section_id, tag_id)
);

-- 向量表（支持多源向量存储）
-- 通用向量存储表
CREATE TABLE embeddings (
    id SERIAL PRIMARY KEY,
    source_id INTEGER NOT NULL,
    vector public.vector(1024)
    -- 可加 UNIQUE (source_type, source_id) 做去重
);

-- 标签之间的关联表
CREATE TABLE tag_links (
    source_tag_id INTEGER REFERENCES tags(id) NOT NULL,
    target_tag_id INTEGER REFERENCES tags(id) NOT NULL,
    relation_type TEXT DEFAULT 'related'::text,
    UNIQUE (source_tag_id, target_tag_id)
);