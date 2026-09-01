-- 1. Access control
create policy "Only permanent users can post to the news feed"
on news_feed as restrictive for insert
to authenticated
with check ((select (auth.jwt()->>'is_anonymous')::boolean) is false );

create policy "Anonymous and permanent users can view the news feed"
on news_feed for select
                                   to authenticated
                                   using ( true );

